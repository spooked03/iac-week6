from nicegui import ui


@ui.page("/")
def index():
    ui.label("Team Fortress 2 - Heavy").classes(
        "text-h3 text-center q-mb-md full-width"
    )
    ui.image("tf2-heavy.jpg").classes("q-mx-auto").style(
        "max-width: 800px; width: 100%;"
    )


ui.run(host="0.0.0.0", port=8080)
