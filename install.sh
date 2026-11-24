# 安装 idea-clarifier-personal 到本机 Agent 技能目录
#
#   ./install.sh                   装到检测到的所有技能目录
#   ./install.sh --target claude   只装到 ~/.claude/skills
#   ./install.sh --target workbuddy
#   ./install.sh --dry-run         只看会做什么，不动文件
#
# 已存在同名 Skill 时会先改名为 <name>.bak.<时间戳>，不会静默覆盖。
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="auto"
DRY=0

if [ ! -f "$SRC/SKILL.md" ]; then
  echo "当前目录下没有 SKILL.md，请在本 Skill 目录内运行。" >&2
  exit 1
fi

# 目录名以 SKILL.md 里声明的 name 为准：仓库名可以随便取，技能名必须一致
NAME="$(awk '/^name:/{print $2; exit}' "$SRC/SKILL.md" | tr -d '"\r')"
[ -z "$NAME" ] && NAME="$(basename "$SRC")"

while [ $# -gt 0 ]; do
  case "$1" in
    --target) MODE="${2:-auto}"; shift 2 ;;
    --target=*) MODE="${1#*=}"; shift ;;
    --dry-run) DRY=1; shift ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "未知参数：$1"; exit 1 ;;
  esac
done

if ! printf '%s' "$NAME" | grep -qE '^[a-z0-9-]+$'; then
  echo "目录名不符合 Skill 命名规范（小写字母、数字、连字符）：$NAME" >&2
  exit 1
fi

STAMP="$(date +%Y%m%d%H%M%S)"
INSTALLED=0

install_to() {
  base="$1"
  dest="$base/$NAME"

  if [ "$DRY" -eq 1 ]; then
    if [ -e "$dest" ]; then
      echo "[dry-run] 会把 $dest 改名为 $dest.bak.$STAMP，然后写入新文件"
    else
      echo "[dry-run] 会创建 $dest"
    fi
    return
  fi

  mkdir -p "$base"

  if [ -e "$dest" ]; then
    mv "$dest" "$dest.bak.$STAMP"
    echo "已备份旧版本 -> $dest.bak.$STAMP"
  fi

  mkdir -p "$dest"
  ( cd "$SRC" && tar --exclude=./.git --exclude='*.bak.*' --exclude=./.gitignore -cf - . ) \
    | ( cd "$dest" && tar -xf - )

  echo "已安装 -> $dest"
  INSTALLED=$((INSTALLED + 1))
}

case "$MODE" in
  claude)    install_to "$HOME/.claude/skills" ;;
  workbuddy) install_to "$HOME/.workbuddy/skills" ;;
  auto)
    found=0
    for base in "$HOME/.claude/skills" "$HOME/.workbuddy/skills"; do
      if [ -d "$(dirname "$base")" ]; then
        install_to "$base"
        found=1
      fi
    done
    if [ "$found" -eq 0 ]; then
      echo "没有找到 ~/.claude 或 ~/.workbuddy。"
      echo "请手动复制：cp -r \"$SRC\" ~/.claude/skills/"
      exit 1
    fi
    ;;
  *) echo "未知目标：$MODE（可用 auto / claude / workbuddy）"; exit 1 ;;
esac

echo
echo "完成。新开一个 Agent 会话后生效——技能只在会话启动时扫描。"
