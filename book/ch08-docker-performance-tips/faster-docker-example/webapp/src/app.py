from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello_world():
    return '<p>Hello, World from faster Docker and Python with <code>uv python</code>!</p>'


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=False)
