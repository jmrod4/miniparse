perl -i -pe 's/_index\.html/top-index.html/g' css/*
perl -i -pe 's/_index\.html/top-index.html/g' js/*
perl -i -pe 's/_index\.html/top-index.html/g' Miniparse/*
perl -i -pe 's/_index\.html/top-index.html/g' ./*
mv top-index.html top-index.html

