# Teller.Sandbox

## Solution Explanation

The important thing about my solution is I am not resolving/generating data when clients make a request, instead I am generating the data in compile time. In runtime we only have to resolve the links and the dates, which is straightforward compared with generating everything every time.

In order to achieve this I create 10 `profiles` when the app starts. A profile is a set of accounts with transactions, mocking a user profile with his/her accounts/transactions. Then, with the user id (in practice is the auth token), we resolve with a hash which profile is for that user, so it will get always the same results.

The transactions are built with one field called `days_from_today` which is an integer, so `0` means today, `1` means yesterday (`today - 1 day`) and so on. Then is easy to generate the dates on runtime.

The links are also generated in runtime, just in case we change the config of the project and the url is not the tipycal `localhost:4000` anymore.

This project has 100% coverage, also running Dialyzer and Credo, you can check it running `mix check`

### Optional requirements

I have completed the pagination requirement. In order to achieve it I took some assumptions:

- if the `count` field is not an integer we respond with an unprocessable entity error (422)
- The `from_id` indicates the last element we got, so the next one will be the first element in the next query.
- if the `from_id` is not an existing transaction id we respond with an empty list

## Valid Auth tokens

The tokens supported by the system are:

```
    "test_tok_user1"
    "test_tok_user2"
    "test_tok_user3"
    "test_tok_user4"
    "test_tok_user5"
    "test_tok_user6"
```

## Running the system

Download the dependencies

```
> mix deps.get
```

Run the tests with 100% coverage and making credo/dialyzer happy (optional)

```
> mix check
```

Start the service:

```
> mix phx.server
```

now the system is running on `http://localhost:4000/accounts`