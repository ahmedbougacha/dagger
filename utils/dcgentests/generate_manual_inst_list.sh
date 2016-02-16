pdftotext -eol unix -table -clip Intel_ref_manual.pdf
cat intel_isa_manual.txt | grep 'Vol. 2' | grep -e -- | cut -d- -f1 | sort | uniq
