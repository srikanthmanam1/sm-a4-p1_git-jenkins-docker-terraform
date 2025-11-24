from flask import Flask
import time

app = Flask(__name__)

@app.route("/")
def home():
   print("No 1 Printed immediately.")
   time.sleep(5) # Suspends execution for 5 seconds
   print("No 1 Printed after 5 seconds.")
   return "Hello from Jenkins + Docker + Terraform + AWS!"

if __name__ == "__main__":
   app.run(host="0.0.0.0", port=8080)
   #print("No 2 Printed immediately.")
   #time.sleep(30) # Suspends execution for 30 seconds
   #print("No 2 Printed after 30 seconds.")

