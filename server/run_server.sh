# List all ip addresses
echo "List of available ip addresses"
hostname -I

echo "Enter your ip address: "

read ip_addr

echo "Run flask server"
export FLASK_APP=app.py
flask run -h $ip_addr -p 5000
