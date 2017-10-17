
import consul
import sys, getopt, argparse
import pprint

c = consul.Consul()
pp = pprint.PrettyPrinter(indent=3)


def get_consul_keys(key, recurse=False, token=None, dc=None):
  keys = c.kv.get(key)[1]
  print (pp.pprint(keys))
  return keys


def main(argv):

  #TODO
#  parser = argparse.ArgumentParser(description='Work with Consul Key Values.')
#  parser.add_argument('keys', metavar='N', type=string, nargs='+',
#                      help='an integer for the accumulator')
#  parser.add_argument('--sum', dest='accumulate', action='store_const',
#                      const=sum, default=max,
#                      help='sum the integers (default: find the max)')
#
#  args = parser.parse_args()

  action = argv[1]
  key    = argv[2]
  recurse = True if argv[3] else False
  print (key)

  if action == "get":
    get_consul_keys(key, recurse=True)


if __name__ == "__main__":
  main(sys.argv[0:])
