from requests.auth import AuthBase


class HTTPBearerAuth(AuthBase):
    token = ''

    def __init__(self, token):
        self.token = token

    def __call__(self, r):
        r.headers["authorization"] = "Bearer {}".format(self.token)
        return r
