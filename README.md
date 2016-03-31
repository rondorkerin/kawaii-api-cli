# KawaiiAPI CLI Tool_

Build NativeSync apps on the command line!

## Installation and Setup

_How do I get started?_

Install from rubygems (Recommended)

1. _`gem install kawaiiapi_cli`_

Install from the repo (requires rake and bundler).

1. _Clone the repo._
2. _`rake build`_
3. _`rake install` (Requires root privileges)._

You now have access to the `ns` command.

_Required Gems_

If you install from rubygems then you will not need to install these required gems yourself. The gem package manager will attempt to install the proper versions for you.

1. thor >= 0.17.0 and < 0.19
2. json >= 1.7.7 and < 1.8
3. rest-client >= 1.6.7 and < 1.7

_Required system packages_

1. ruby-devel
2. make
3. gcc

_How can I add the repo bin path to my environment PATH variable?_

Place it in your ~/.bash_profile file.  You should end up with something like this:
`export PATH=$PATH:/path/to/kawaiiapi-cli/repo/bin/`

## How to use (Commands)

before you can use the kawaiiapi CLI, you must first login:

`ns init`

This will create a file called .kawaiiapi which will contain your API key for later API calls.

After that, you can do any call in the NativeSync system with the following template:

`ns <service_name> <function_name> [--credentials_name=<credentials identifier>] [--input-file=<path>] [--output-file=<path>] [<args>]`

`input-file` specifies a path to a JSON-encoded file that the `ns` tool will receive the input data from.

Alternatively, you can specify key-value pairs that will input to your function

Example:

`ns kawaiiapi example_function --foo=bar --hello=world`

If an argument needs to be loaded from a file, specify a file extension in your argument.

Example:

`ns kawaiiapi create_cloud_function --program=my_function.js --function-name=my_test_function schedule="* * * * * *"`

## Issues

If you encounter issues with this project, please open a github support ticket.


## Contributing changes

I welcome all contributions.  If you would like to include a new feature or bug fix, simply open a pull request and explain the problem or feature you contributed. I will review the contribution at that point. Feel free to contact nick@kawaiiapi.io with contribution ideas.

## License
See LICENSE file.

## Thanks
Many thanks to the people at gitlab for releasing their CLI open source, I used their CLI tool as a template for this project.
https://github.com/drewblessing/gitlab-cli
