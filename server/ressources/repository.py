from flask_restful import Resource, reqparse


# We save our data in a python list, for simplicity
repositories = [

    {
        "Index": "BLUE-FILTER",
        "Title": "IOT Image Processing",
        "Version": "001",
        "Description": "blue filter logic",
        "Changelog": ["03.10.2020 Primary release"],
        "File": "blue_filter.bin",
        "Date": "03.10.2020",
        "Checksum": ""
    },

    {
        "Index": "GREEN-FILTER",
        "Title": "IOT Image Processing",
        "Version": "001",
        "Description": "green filter logic",
        "Changelog": ["03.10.2020 Primary release"],
        "File": "green_filter.bin",
        "Date": "03.10.2020",
        "Checksum": ""
    },
    
    {
        "Index": "RED-FILTER",
        "Title": "IOT Image Processing",
        "Version": "001",
        "Description": "red filter logic",
        "Changelog": ["03.10.2020 Primary release"],
        "File": "red_filter.bin",
        "Date": "03.10.2020",
        "Checksum": ""
    },
    
    {
        "Index": "ROTATE_LEFT",
        "Title": "IOT Knight Rider",
        "Version": "001",
        "Description": "LED rotate left",
        "Changelog": ["03.10.2020 Primary release"],
        "File": "rotate_left.bin",
        "Date": "03.10.2020",
        "Checksum": ""
    },
    
    {
        "Index": "ROTATE_RIGHT",
        "Title": "IOT Knight Rider",
        "Version": "001",
        "Description": "LED rotate right",
        "Changelog": ["03.10.2020 Primary release"],
        "File": "rotate_right.bin",
        "Date": "03.10.2020",
        "Checksum": ""
    }
]

class Repository(Resource):
    def get(self, index):
        for repo in repositories:
            if index == repo["Index"]:
                return repo, 200
            else:
                continue
        return "Repository not found", 404

    def post(self, index):
        parser = reqparse.RequestParser()
        parser.add_argument("Title")
        parser.add_argument("Version")
        parser.add_argument("Description")
        parser.add_argument("Changelog")
        parser.add_argument("File")
        parser.add_argument("Date")
        parser.add_argument("Checksum")
        args = parser.parse_args()

        for repo in repositories:
            if index == repo["Index"]:
                return "Repository with index {} already exists".format(index), 400

        repo = {
            "Index": index,
            "Title": args["Title"],
            "Version": args["Version"],
            "Description": args["Description"],
            "Changelog": [args["Changelog"]],
            "File": args["File"],
            "Date": args["Date"],
            "Checksum": args["Checksum"]
        }

        repositories.append(repo)
        return repo, 201

    def put(self, index):
        parser = reqparse.RequestParser()
        parser.add_argument("Title")
        parser.add_argument("Version")
        parser.add_argument("Description")
        parser.add_argument("Changelog")
        parser.add_argument("File")
        parser.add_argument("Date")
        parser.add_argument("Checksum")
        args = parser.parse_args()

        for repo in repositories:
            if index == repo["Index"]:
                if args["Title"] is not None:
                    repo["Title"] = args["Title"]
                if args["Version"] is not None:
                    repo["Version"] = args["Version"]
                if args["Description"] is not None:
                    repo["Description"] = args["Description"]
                if args["Changelog"] is not None:
                    repo["Changelog"].append(args["Changelog"])
                if args["File"] is not None:
                    repo["File"] = args["File"]
                if args["Date"] is not None:
                    repo["Date"] = args["Date"]
                if args["Checksum"] is not None:
                    repo["Checksum"] = args["Checksum"]

                return repo, 200

        repo = {
            "Index": index,
            "Title": args["Title"],
            "Version": args["Version"],
            "Description": args["Description"],
            "Changelog": [args["Changelog"]],
            "File": args["File"],
            "Date": args["Date"],
            "Checksum": args["Checksum"]
        }

        repositories.append(repo)
        return repo, 201

    def delete(self, index):
        for repo in repositories:
            if index == repo["Index"]:
                repositories.remove(repo)
                return "Repository {} is deleted".format(index), 200
