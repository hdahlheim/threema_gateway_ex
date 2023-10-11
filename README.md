# ThreemaGateway Elixir

Work in progress unofficial Elixir SDK for the Threema Gateway API.

> [!WARNING]
> This SDK has not yet been tested against the Threema Gateway API.

The code is mostly based on the [Rust SDK](https://github.com/dbrgn/threema-gateway-rs/tree/master).

## Supported Features

As mentioned above, the features have not been tested against the public Gateway API. They should work as they are for the most part a direct port of the Rust SDK.

### Sending

- [x] Send simple messages
- [x] Send end-to-end encrypted messages

### Encrypting

- [x] Encrypt raw bytes
- [x] Encrypt text messages
- [x] Encrypt image messages
- [x] Encrypt file messages
- [ ] Encrypt delivery receipt messages

### Receiving

- [x] Decode incoming request body
- [x] Verify MAC of incoming message
- [x] Decrypt incoming message
- [ ] Decode incoming message

### Files

- [ ] Upload files
- [ ] Download files


### Lookup

- [x] Look up ID by phone number
- [x] Look up ID by e-mail
- [x] Look up ID by phone number hash
- [x] Look up ID by e-mail hash
- [x] Look up capabilities by ID
- [x] Look up public key by ID
- [x] Look up remaining credits

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `threema_gateway_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:threema_gateway, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/threema_gateway_ex>.

