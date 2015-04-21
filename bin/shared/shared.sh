# env files look like:
#
# FOO=bar
# BAZ='quux with spaces'
# 
# remove blank lines, then export the files as environment variables
envfiles()
{
  eval $(sed -e "/^$/d" -e "s/^/export /" "$@")
}
