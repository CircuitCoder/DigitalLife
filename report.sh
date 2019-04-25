rm -f report.md report.tex report.pdf
touch report.md

cat README.md >> report.md
echo "\n## 附: 源代码\n" >> report.md

for file in *.vhdl; do
  echo "\n### $file\n" >> report.md
  echo "\`\`\`vhdl" >> report.md
  cat $file >> report.md
  echo "\`\`\`\n" >> report.md
done

rm -rf _minted_
mkdir _minted_

pandoc --filter pandoc-minted.py -o report.tex report.md --template ../template.tex
xelatex -shell-escape report.tex
