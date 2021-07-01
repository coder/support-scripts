# Coder Support Scripts

The scripts in this repository are meant to automate commands typically run when configuring Coder
and troubleshooting issues with the platform.

## Troubleshooting

This directory contains scripts you can use to generate logs relevant for debugging cluster-level
issues. These scripts will generate output to both `stdout` and a `*_output.txt` file. Send us
your `.txt` file for further assistance with troubleshooting.

## Upgrade & Teardown

These scripts automate commands run to upgrade your Coder deployment and uninstall the platform (while keeping your Kubernetes cluster and non-Coder resources intact).

## Usage & Requirements

You will need cluster-admin access to your Kubernetes cluster and `kubectl` installed on your local machine. To run these scripts:

    1. Open your terminal
    2. Clone this repository
    3. Connect to the Kubernetes cluster of which Coder is deployed on
    4. `cd` into the `support-scripts` repo
    5. Run `./script-name.sh`
