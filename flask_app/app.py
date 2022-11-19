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


app = Flask(__name__, template_folder="templates")
app.config.from_object("config.Config")
app.register_blueprint(view, url_prefix="/")

db = SQLAlchemy(app)
db.init_app(app)
migrate = Migrate(app, db)


class Pet(db.Model):
    __tablename__ = "pets"
    id = db.Column("pet_id", db.Integer, primary_key=True)
    name = db.Column(db.String())
    animal = db.Column(db.String())
    breed = db.Column(db.String())
    birthday = db.Column(db.String())


def __init__(self, name, animal, breed, birthday):
    self.name = name
    self.animal = animal
    self.breed = breed
    self.birthday = birthday


@app.route("/")
def index():
    db.create_all()
    return render_template("index.html", pets=Pet.query.all())


@app.route("/add/", methods=["GET", "POST"])
def add():
    db.create_all()
    if request.method == "POST":
        if (
            not request.form["name"]
            or not request.form["animal"]
            or not request.form["breed"]
            or not request.form["birthday"]
        ):
            flash("Please enter all the fields", "error")
        else:
            pet = Pet(
                name=request.form["name"],
                animal=request.form["animal"],
                breed=request.form["breed"],
                birthday=request.form["birthday"],
            )

            db.session.add(pet)
            db.session.commit()

            # flash('Record was successfully added')
            return redirect(url_for("index"))
    return render_template("add.html")


@app.route("/<int:pet_id>/edit/", methods=("GET", "POST"))
def edit(pet_id):
    db.create_all()
    pet = Pet.query.get_or_404(pet_id)

    if request.method == "POST":

        if (
            not request.form["name"]
            or not request.form["animal"]
            or not request.form["breed"]
            or not request.form["birthday"]
        ):
            flash("Please enter all the fields", "error")
        else:
            name = request.form["name"]
            animal = request.form["animal"]
            breed = request.form["breed"]
            birthday = request.form["birthday"]

            pet.name = name
            pet.animal = animal
            pet.breed = breed
            pet.birthday = birthday

            db.session.add(pet)
            db.session.commit()

            # flash('Record was successfully updated')
            return redirect(url_for("index"))

    return render_template("edit.html", pet=pet)


@app.post("/<int:pet_id>/delete/")
def delete(pet_id):
    db.create_all()
    pet = Pet.query.get_or_404(pet_id)
    db.session.delete(pet)
    db.session.commit()
    return redirect(url_for("index"))


@app.route("/test_db")
def test_db():
    db.create_all()
    # db.session.commit()
    pet = Pet.query.first()
    if not pet:
        u = Pet(
            name="Charlie",
            animal="Dog",
            breed="Labrador Retriever",
            birthday="2018-03-13",
        )
        db.session.add(u)
        db.session.commit()
    pet = Pet.query.first()
    return "Pet '{}' is in the database".format(
        pet.name, pet.animal, pet.breed, pet.birthday
    )


@app.route("/unsplash")
def unsplash():
    return render_template("unsplash.html")


# For debugging only
if __name__ == "__main__":
    app.run(host="localhost", port=5000, debug=True)
