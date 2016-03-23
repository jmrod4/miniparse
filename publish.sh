cp -r ../../prj/miniparse/doc/* .
perl -i -pe 's/_index\.html/top-index.html/g' ./*
perl -i -pe 's/_index\.html/top-index.html/g' css/*
perl -i -pe 's/_index\.html/top-index.html/g' js/*
perl -i -pe 's/_index\.html/top-index.html/g' Miniparse/*
perl -i -pe 's/_index\.html/top-index.html/g' ./*
mv _index\.html top-index.html
git checkout gh-pages
git add .
git commit -m "doc update"
git push

