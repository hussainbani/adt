import pytest
from api import create_app


@pytest.fixture
def token():
    return "valid"


@pytest.fixture
def app(token):
    return create_app(token)


@pytest.fixture()
def client(app):
    return app.test_client()
