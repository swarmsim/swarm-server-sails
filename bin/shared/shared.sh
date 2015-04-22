# env files look like:
#
# FOO=bar
# BAZ='quux with spaces'
#
# remove blank lines and comments
readenv()
{
  sed -e "/^$/d" -e "/^#.*$/d" "$@"
}

# remove blank lines and comments, then export the files as environment variables
exportenv()
{
  eval $(readenv -e "s/^/export /" "$@")
}
