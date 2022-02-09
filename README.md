# Quick Proof of Concept for Versioning APIs (in Ruby).

Inspired by [Stripe API versioning](https://stripe.com/blog/api-versioning).

## Run

```
gem install sinatra
ruby server.rb

# In a separate window
curl -H "X-ZendeskAPI-Version: 2020" "localhost:4567/?firstname=Zendesk&what=zen"
curl -H "X-ZendeskAPI-Version: 2021" "localhost:4567/?first_name=Programming&what=cool" # (firstname -> first_name)
curl -H "X-ZendeskAPI-Version: 2022" "localhost:4567/?first_name=Teamwork&is=awesome" # (what -> is)
curl -H "X-ZendeskAPI-Version: 2023" "localhost:4567/?full_name=Teamwork&is=awesome" # (first_name -> full_name)
```
