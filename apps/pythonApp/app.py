from flask import Flask
import sys

app = Flask(__name__)

@app.route('/')
def version():
    return sys.version

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
