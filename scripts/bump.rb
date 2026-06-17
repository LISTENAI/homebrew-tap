#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Update the tap's formulae/casks to the latest upstream release.
#
# Usage: scripts/bump.rb [<name from projects.yaml>|all]
#
# Everything project-specific lives in ../projects.yaml — to manage a new
# project, add an entry there (and write its initial .rb once); this script and
# the workflow need no edits for an existing type. For each project it reads the
# latest GitHub release, takes the sha256 straight from the release asset digests
# (no download needed), rewrites version + sha256 in the matching .rb, and commits
# per project when something changed.
#
# Requires: gh (authenticated via GH_TOKEN), git, ruby.

require "yaml"
require "json"

ROOT = File.expand_path("..", __dir__)
MANIFEST = File.join(ROOT, "projects.yaml")

# Run a command (no shell, so no quoting/injection) and return its stdout.
def sh(*args)
  out = IO.popen(args, &:read)
  raise "command failed: #{args.join(' ')}" unless $?.success?
  out
end

def git(*args)
  sh("git", "-C", ROOT, *args)
end

def latest_release(repo)
  JSON.parse(sh("gh", "release", "view", "--repo", repo, "--json", "tagName,assets"))
end

# Bare sha256 (no "sha256:" prefix) of the asset whose name ends with `suffix`.
def digest(release, suffix)
  asset = release["assets"].find { |a| a["name"].end_with?(suffix) }
  raise "no release asset ending with #{suffix.inspect}" unless asset
  asset["digest"].sub(/\Asha256:/, "")
end

# Rewrite `file` in place via the block, but only touch disk if it changed.
def rewrite(file)
  original = File.read(file)
  updated = original.dup
  yield updated
  File.write(file, updated) if updated != original
end

def commit_if_changed(file, name, version)
  if git("status", "--porcelain", "--", file).strip.empty?
    puts "#{name}: already at #{version}, nothing to do"
  else
    git("add", file)
    git("commit", "-m", "#{name}: update to #{version}")
    puts "#{name}: bumped to #{version}"
  end
end

# Formula: one universal asset. The url carries a literal version
# (…/download/vX/…), so we rewrite that segment too; the sha256 is the plain
# `sha256 "…"` line.
def bump_formula(proj)
  release = latest_release(proj["repo"])
  version = release["tagName"].delete_prefix("v")
  sha = digest(release, proj["assets"]["default"])
  file = File.join(ROOT, proj["file"])
  rewrite(file) do |s|
    s.sub!(/^(\s*)version ".*"/) { "#{$1}version \"#{version}\"" }
    s.sub!(%r{/releases/download/v[^/]*/}) { "/releases/download/v#{version}/" }
    s.sub!(/^(\s*)sha256 ".*"/) { "#{$1}sha256 \"#{sha}\"" }
  end
  commit_if_changed(file, proj["name"], version)
end

# Per-arch formula: arm/intel each have their own url + sha256 on consecutive
# lines. The url interpolates #{version} (so it self-updates), leaving only the
# version line and the two sha256 lines to rewrite. Each sha256 is anchored on
# the arch's asset token in the url line right above it, so order doesn't matter.
def bump_formula_arch(proj)
  release = latest_release(proj["repo"])
  version = release["tagName"].delete_prefix("v")
  file = File.join(ROOT, proj["file"])
  rewrite(file) do |s|
    s.sub!(/^(\s*)version ".*"/) { "#{$1}version \"#{version}\"" }
    %w[arm intel].each do |arch|
      suffix = proj["assets"][arch]
      sha = digest(release, suffix)
      re = /(url "[^"]*#{Regexp.escape(suffix)}"[ \t]*\n[ \t]*sha256 ")[0-9a-f]{64}(")/
      s.sub!(re) { "#{$1}#{sha}#{$2}" }
    end
  end
  commit_if_changed(file, proj["name"], version)
end

# Cask: per-arch assets. The url uses #{version}/#{arch}, so only the version
# line and the two `arm:`/`intel:` sha256 lines need rewriting.
def bump_cask(proj)
  release = latest_release(proj["repo"])
  version = release["tagName"].delete_prefix("v")
  arm = digest(release, proj["assets"]["arm"])
  intel = digest(release, proj["assets"]["intel"])
  file = File.join(ROOT, proj["file"])
  rewrite(file) do |s|
    s.sub!(/^(\s*)version ".*"/) { "#{$1}version \"#{version}\"" }
    s.sub!(/(arm:\s*")[0-9a-f]{64}(")/) { "#{$1}#{arm}#{$2}" }
    s.sub!(/(intel:\s*")[0-9a-f]{64}(")/) { "#{$1}#{intel}#{$2}" }
  end
  commit_if_changed(file, proj["name"], version)
end

target = ARGV[0] || "all"
projects = YAML.safe_load(File.read(MANIFEST))
selected = projects.select { |p| target == "all" || p["name"] == target }
abort "no project named '#{target}' in projects.yaml" if selected.empty?

selected.each do |proj|
  case proj["type"]
  when "formula"      then bump_formula(proj)
  when "formula-arch" then bump_formula_arch(proj)
  when "cask"         then bump_cask(proj)
  else abort "#{proj['name']}: unknown type '#{proj['type']}' in projects.yaml"
  end
end
