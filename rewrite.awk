# rewrite.awk: convert nginx rewrite rules to Caddyfile rewrite rules
# awk -f rewrite.awk htaccess-nginx.txt
/^rewrite / {
	t = gensub("\\\$([0-9])", "{\\1}", "g", $3) 
	print "\trewrite {\n\t\tregexp " $2 "\n\t\tto " t "\n\t}\n"
}
