from patterns.pattern import Pattern


class SimplePattern(Pattern):
    def __init__(self, name):
        super().__init__(name)
        print("SimplePattern!")

