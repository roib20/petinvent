from flask import (
    Flask,
    request,
    flash,
    url_for,
    redirect,
    render_template,
    make_response,
)
from view import view
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from datetime import datetime


app = Flask(__name__, template_folder="src/templates", static_folder="src/static")
app.config.from_object("config.Config")
app.register_blueprint(view, url_prefix="/")

db = SQLAlchemy(app)
db.init_app(app)
migrate = Migrate(app, db)


# class Pet(db.Model):
#     __tablename__ = "pets"
#     id = db.Column("pet_id", db.Integer, primary_key=True)
#     name = db.Column(db.String(64))
#     animal = db.Column(db.String(64))
#     species = db.Column(db.String(64))
#     birthday = db.Column(db.Date())


class Task(db.Model):
    __tablename__ = "tasks"
    id = db.Column("task_id", db.Integer, primary_key=True)
    title = db.Column(db.String(64))
    desc = db.Column(db.String(64))
    priority = db.Column(db.String(64))
    due_date = db.Column(db.Date())


def __init__(self, title, desc, priority, due_date):
    self.title = title
    self.desc = desc
    self.priority = priority
    self.due_date = due_date


@app.route("/")
def index():
    db.create_all()
    return render_template("index.html", task=Task.query.all())


@app.route("/create/", methods=["GET", "POST"])
def create():
    db.create_all()
    if request.method == "POST":
        if (
            not request.form["title"]
            or not request.form["desc"]
            or not request.form["priority"]
            or not request.form["due_date"]
        ):
            flash("Please enter all the fields", "error")
        else:
            task = Task(
                title=request.form["title"],
                desc=request.form["desc"],
                priority=request.form["priority"],
                due_date=request.form["due_date"],
            )

            db.session.add(task)
            db.session.commit()

            # flash('Record was successfully added')
            return redirect(url_for("index"))
    return render_template("create.html")


@app.route("/<int:task_id>/edit/", methods=("GET", "POST"))
def edit(task_id):
    db.create_all()
    task = Task.query.get_or_404(task_id)

    if request.method == "POST":

        if (
            not request.form["title"]
            or not request.form["desc"]
            or not request.form["priority"]
            or not request.form["due_date"]
        ):
            flash("Please enter all the fields", "error")
        else:
            title = request.form["title"]
            desc = request.form["desc"]
            priority = request.form["priority"]
            due_date = request.form["due_date"]

            task.title = title
            task.desc = desc
            task.priority = priority
            task.due_date = due_date

            db.session.add(task)
            db.session.commit()

            # flash('Record was successfully updated')
            return redirect(url_for("index"))

    return render_template("edit.html", task=task)


@app.post("/<int:task_id>/delete/")
def delete(task_id):
    db.create_all()
    pet = Task.query.get_or_404(task_id)
    db.session.delete(task)
    db.session.commit()
    return redirect(url_for("index"))


@app.route("/test_db")
def test_db():
    db.create_all()
    # db.session.commit()
    task = Task.query.first()
    if not task:
        u = Task(
            title="Charlie",
            desc="Dog",
            priority="Labrador Retriever",
            due_date=datetime(2018, 3, 13)
        )
        db.session.add(u)
        db.session.commit()
    task = Task.query.first()
    return "Task '{}' is in the database".format(
        task.title, task.desc, task.priority, task.due_date
    )


@app.route("/unsplash")
def unsplash():
    return render_template("unsplash.html")


# For debugging only
if __name__ == "__main__":
    app.run(host="localhost", port=5000, debug=True)
