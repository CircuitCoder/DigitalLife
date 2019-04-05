rm -f report.md report.tex report.pdf
touch report.md

cat README.md >> report.md
echo "\n## 附: 源代码\n" >> report.md
echo "\n### lighten.vhdl\n" >> report.md
echo "\`\`\`vhdl" >> report.md
cat lighten.vhdl >> report.md
echo "\`\`\`\n" >> report.md

echo "\n### tb.vhdl\n" >> report.md
echo "\`\`\`vhdl" >> report.md
cat tb.vhdl >> report.md
echo "\`\`\`" >> report.md

rm -rf _minted_
mkdir _minted_

pandoc --filter pandoc-minted.py -o report.tex report.md --template ./template.tex
xelatex -shell-escape report.tex
