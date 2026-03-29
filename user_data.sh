#!/bin/bash
set -e

# Log all output for debugging
exec > /var/log/eda-setup.log 2>&1
echo "=== EDA Compute Node Setup ==="
echo "Started: $(date)"

# System updates
apt-get update -y
apt-get upgrade -y

# Install EDA simulation tools
apt-get install -y \
  ngspice \
  python3 \
  python3-pip \
  python3-venv \
  awscli \
  git \
  make \
  build-essential

# Create working directories
mkdir -p /opt/eda/{simulations,results,scripts}

# Configure AWS CLI default region (credentials come from instance role)
mkdir -p /root/.aws
cat > /root/.aws/config << 'AWSEOF'
[default]
region = us-west-2
output = json
AWSEOF

# Create a helper script that runs a SPICE simulation and uploads results to S3
cat > /opt/eda/scripts/run_and_upload.sh << 'SCRIPTEOF'
#!/bin/bash
# Usage: run_and_upload.sh <netlist_file> <s3_bucket>
NETLIST=$1
S3_BUCKET=$2

if [ -z "$NETLIST" ] || [ -z "$S3_BUCKET" ]; then
  echo "Usage: run_and_upload.sh <netlist_file> <s3_bucket>"
  exit 1
fi

BASENAME=$(basename "$NETLIST" .spice)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULT_DIR="/opt/eda/results/${BASENAME}_${TIMESTAMP}"
mkdir -p "$RESULT_DIR"

echo "Running simulation: $NETLIST"
ngspice -b "$NETLIST" -o "$RESULT_DIR/output.log" -r "$RESULT_DIR/rawdata.raw"

echo "Uploading results to s3://$S3_BUCKET/$BASENAME/$TIMESTAMP/"
aws s3 cp "$RESULT_DIR" "s3://$S3_BUCKET/$BASENAME/$TIMESTAMP/" --recursive

echo "Done. Results at: s3://$S3_BUCKET/$BASENAME/$TIMESTAMP/"
SCRIPTEOF
chmod +x /opt/eda/scripts/run_and_upload.sh

# Verify installations
echo "=== Verification ==="
echo "ngspice: $(ngspice --version 2>&1 | head -1)"
echo "python3: $(python3 --version)"
echo "aws: $(aws --version)"
echo "Setup complete: $(date)"
