# JSONify
## Pydantic Schema to SqlAlchemy Model
```python
def create(self, db: Session, obj_in: ExampleModelCreate):
	db_obj = self.model(**obj_in.model_dump())
```

## SqlAlchemyModel to Pydantic Schema
```python
def list_items(self, db: Session) -> ExampleModelList:
	items = crud_example.list(db)
	return ExampleModelList(items=[ExampleModelInDB.model_validate(item) for item in items])
```

## Return from API
```python
@app.get("/examples/", response_model=ExampleModelList)
def list_examples(db: Session = Depends(get_db)):
    listing_op = ExampleModelListOperation()
    return listing_op.list_items(db)
```

# TODO
 - [ ]  List out all ORM feature like I did in kotlin
 - [ ] sample code for each of it
## Doubts
- datetime serializations ? (yes, it works)
- what if column names and pydantic key name doesn't match ?