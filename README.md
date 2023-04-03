# Compare-FortiOSHash PowerShell Script

`Compare-FortiOSHash` is a PowerShell script that compares the hash of a downloaded FortiOS .out file with a hash provided by Fortinet. It supports both MD5 and SHA512 hashes, and can check a TXT or XML file for the hash or take input from the command line. It also checks the name of the downloaded file to make sure it matches the provided name. The hashes are displayed side by side in all caps for easy comparison.

## Usage

To use the script, run `Compare-FortiOSHash.ps1` in PowerShell with the following parameters:

- `-FilePath` (mandatory): the path to the downloaded file.
- `-Hash` (optional): the hash provided by Fortinet. Can be provided via command line input or checked from a TXT or XML file.
- `-Algorithm` (optional): the hash algorithm to use. Supports MD5, SHA512, or both.
- `-Name` (optional): the expected name of the downloaded file.

For example: Compare-FortiOSHash.ps1 -FilePath C:\Downloads\file.out -Hash ABCDEF123456 -Algorithm SHA512 -Name file.out

## Documentation

The script includes version and author information in its documentation.

## Requirements

The script requires PowerShell 5.1 or later.

## License

This script is licensed under the [MIT License](LICENSE).

## Contributions

Contributions are welcome! Please feel free to open issues or submit pull requests.

## Credits

This script was created by Gabriel Jensen.
