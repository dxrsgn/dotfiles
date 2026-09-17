#!/usr/bin/env bash
# Mirror tmux key bindings onto the Russian (ЙЦУКЕН) layout.
# For every binding on a Latin key, bind the Cyrillic key in the same
# physical position to the same command. Only Cyrillic keys are ever bound,
# so existing bindings (e.g. `,` `.` `;` `?`) are never overwritten.
set -euo pipefail

TABLES=(prefix copy-mode-vi)

declare -A RU=(
  [q]=й [w]=ц [e]=у [r]=к [t]=е [y]=н [u]=г [i]=ш [o]=щ [p]=з ['[']=х [']']=ъ
  [a]=ф [s]=ы [d]=в [f]=а [g]=п [h]=р [j]=о [k]=л [l]=д [';']=ж ["'"]=э
  [z]=я [x]=ч [c]=с [v]=м [b]=и [n]=т [m]=ь [',']=б ['.']=ю ['`']=ё
  [Q]=Й [W]=Ц [E]=У [R]=К [T]=Е [Y]=Н [U]=Г [I]=Ш [O]=Щ [P]=З ['{']=Х ['}']=Ъ
  [A]=Ф [S]=Ы [D]=В [F]=А [G]=П [H]=Р [J]=О [K]=Л [L]=Д [':']=Ж ['"']=Э
  [Z]=Я [X]=Ч [C]=С [V]=М [B]=И [N]=Т [M]=Ь ['<']=Б ['>']=Ю ['~']=Ё
)

out=$(mktemp)
trap 'rm -f "$out"' EXIT

re='^bind-key +(-r +)?-T +([^ ]+) +([^ ]+) +(.*)$'
for table in "${TABLES[@]}"; do
  while IFS= read -r line; do
    [[ $line =~ $re ]] || continue
    repeat=${BASH_REMATCH[1]} key=${BASH_REMATCH[3]} cmd=${BASH_REMATCH[4]}
    mod=
    [[ $key == M-?* ]] && mod=M- key=${key#M-}
    # list-keys escapes some keys, e.g. \" \; \{
    [[ ${#key} -eq 2 && $key == \\? ]] && key=${key:1}
    ru=${RU[$key]-}
    [[ -n $ru ]] || continue
    printf 'bind-key %s-T %s %s%s %s\n' "$repeat" "$table" "$mod" "$ru" "$cmd" >>"$out"
  done < <(tmux list-keys -T "$table" 2>/dev/null)
done

[[ -s $out ]] && tmux source-file "$out"
