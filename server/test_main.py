import main
from flask import json
from unittest import TestCase

class TestIntegrations(TestCase):
    def setUp(self):
        self.app = main.app.test_client()

    def test_1_running(self):
        response = self.app.get('/')
        print(response.data)
        assert b'We are online.' in response.data

    def test_2_getRepostiory_withRightIndex(self):
        response = self.app.get('/api/SOC-LAB-IOT')
        data = json.loads(response.data)
        print(data)
        self.assertEqual(data, repo)

    def test_3_getRepository_withFalseIndex(self):
        response = self.app.get('/api/46418852')
        print(response.data)
        assert b'Repository not found' in response.data

    def test_4_postRepository(self):
        response = self.app.post('api/111', data= repo1)
        data = json.loads(response.data)
        print(data)
        self.assertEqual(data, repo1)
        response = self.app.post('api/111', data=repo1)
        print(response.data)
        assert b'Repository with index 111 already exists' in response.data


    def test_5_putRepository(self):
        response = self.app.put('api/SOC-LAB-IOT', data= changes)
        print(repoChanged)
        data = json.loads(response.data)
        print(data)
        self.assertEqual(data, repoChanged)

    def test_6_deleteRepository(self):
        response = self.app.delete('api/SOC-LAB-IOT')
        print(response.data)
        assert b'Repository SOC-LAB-IOT is deleted' in response.data
        response = self.app.get('api/SOC-LAB-IOT')
        print(response.data)
        assert b'Repository not found"' in response.data



repo = {
        "Index": "SOC-LAB-IOT",
        "Title": "IOT Image Processing",
        "Version": "0.0.1",
        "Description": "",
        "Changelog": ["3.11.2018 Primary release", "4.11.2018 Bug fixing"],
        "File": "file link",
        "Date": "4.11.2018",
        "Checksum": ""
}

changes = {
        "Version": "0.0.5",
        "Changelog": "4.11.2018 additional Bug fixing",
        "Date": "5.11.2018"
}

repoChanged = {
        "Index": "SOC-LAB-IOT",
        "Title": "IOT Image Processing",
        "Version": "0.0.5",
        "Description": "",
        "Changelog": ["3.11.2018 Primary release", "4.11.2018 Bug fixing", "4.11.2018 additional Bug fixing"],
        "File": "file link",
        "Date": "5.11.2018",
        "Checksum": ""
}



repo1 = {
        "Index": "111",
        "Title": "Some Title",
        "Version": "0.0.1",
        "Description": "",
        "Changelog": ["3.11.2018 Primary release"],
        "File": "file link",
        "Date": "4.11.2018",
        "Checksum": ""
}

