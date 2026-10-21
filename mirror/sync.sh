#!/usr/bin/env bash
# GitLab（权威）与 GitHub（执行镜像）之间的同步。
# 原则：QCA 只碰 GitHub；GitLab 是事实源；同步只做显式命令，不做自动双向。
#
# 用法：
#   mirror/sync.sh push-master                          # 骨架/文档推到镜像
#   mirror/sync.sh pull-branch <branch>                 # 拉回 QCA 产出的分支
#   mirror/sync.sh push-branch <branch>                 # 校验后同步回 GitLab
#
# 首次配置：
#   export GITHUB_REPO=owner/Qoder-DataAgent-demo       # 你的 GitHub 仓库
set -euo pipefail

GITLAB="${GITLAB_REMOTE:-origin}"
GITHUB="${GITHUB_REMOTE:-mirror}"

git remote add "$GITLAB" ssh://git@code.alibaba-inc.com/pub-sa/Qoder-DataAgent-demo.git 2>/dev/null || true
git remote add "$GITHUB" "git@github.com:${GITHUB_REPO:?需要设置 GITHUB_REPO，例如 owner/Qoder-DataAgent-demo}.git" 2>/dev/null || true

cmd="${1:-help}"
case "$cmd" in
  push-master)
    git push "$GITHUB" master
    ;;
  pull-branch)
    branch="${2:?用法: pull-branch <branch>}"
    git fetch "$GITHUB" "$branch"
    git checkout -B "$branch" "FETCH_HEAD"
    ;;
  push-branch)
    branch="${2:?用法: push-branch <branch>}"
    # TODO(V1): 在这里接 runs/ 校验（四件套存在、YAML 可解析、handoff 路径有效）
    git push "$GITLAB" "$branch"
    ;;
  *)
    grep '^#' "$0" | sed 's/^# \{0,1\}//'
    ;;
esac
