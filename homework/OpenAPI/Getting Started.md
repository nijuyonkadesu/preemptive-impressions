## Editor
https://editor.swagger.io/
![100%](https://progress-bar.dev/100)
^ progress ... of the [specification](https://learn.openapis.org/specification/)
## Something about OpenAPI
- auto code gen for various languages
- easily understandable standard format, which is easier to understand for humans and computers too (**contracts**, and **specification**)
- auto document generation
- avoid time sinks
- generate boilerplate 
- auto gen mock servers for testing
- https://tools.openapis.org/ tool list
- if could not redesign API, it can be left out from *OpenAPI Description*
- [RESTful, websocket, CoAP]
- it's something like interfaces in programing languages


## Soft landing
Building blocks of OAD: 
- `openapi.yaml` (yaml 1.2) (yaml is superset of json - allows mixing of syntaxes)
- visualization tool: https://openapi-map.apihandyman.io/
- necessary fields are marked in red [any one of paths / components / webhook] is required
 ![[Pasted image 20231107181221.png]]
	 - openapi - version (3.10)
	 - **info** - about the author [title, version]
	 - **paths** - describe all endpoints in a server
		 - query / path **parameters**
		 - **schema** (basic) / **content** (adv)  - must present
			 - customize serialization
		 - **requestbody** 
			 - **content** is must
				 - **headers** with all possible values [application/json, image/jpeg, ...]
				 - **schema**
					 - variable name
					 - [datatype, range, enum, array, refs]
		 - **response**
			 - description
			 - xxx http code
				 - response **schema**

## Component
Allows referencing reusable data class on **parameters**, **schema**, **response** fields
## Documentation 
plox cover the **purpose** of a parameter, the **effect of each value** or possible **interactions** with other parameters
```yaml
paths:
  /audio/volume:
    put:
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: integer
              minimum: 0
              maximum: 11
              description: |
                Current volume for all audio output.
                0 means no audio output (mute).
                10 is the maximum value.
                11 enables the overdrive system (danger!).
                When set to 0 all other audio settings have no effect.
```
[explore these](https://spec.openapis.org/oas/v3.1.0#operation-object) to see what aspects to cover in description of other fields.
how to provide descriptions like a [.md](https://learn.openapis.org/specification/docs#the-commonmark-syntax) file
**example / examples**: whatever that you've `$ref`'ed, populate all variables, now it's an example (like an *object* of a *class* yk)

## Server URLs
all end points can be accessed through these two URLs

```yaml
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0
servers:
  - url: https://api.example.com/
  - url: https://api-staging.example.com/
  - url: https://admin.example.com/
paths:
  /admin/users:
    get:
      summary: Get all users
      description: Retrieves a list of all users.
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema: $ref:'#/components/schemas/UserList'

```
Only the mentioned URL can assess the `/users` endpoint.
It's like *scoping*, like hiding sensitive enpoints from peasants (●'◡'●)
```yaml
paths:
  /admin/users:
    servers:
      - url: https://{username}.example.com:{port}/admin/users/
    get:
      summary: Get all users
      description: Retrieves a list of all users.
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema: $ref:'#/components/schemas/UserList'
```
## Checkpoint  
next dive deep into the rabbit hole `（*＾-＾*）`