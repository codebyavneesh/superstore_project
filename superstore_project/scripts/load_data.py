# Import essential libraries
import pandas as pd
from sqlalchemy import create_engine

# Create engine
engine = create_engine(
    "mysql+pymysql://root:root@localhost:3306/superStoreDB"
)

# Create DataFrame
df = pd.read_csv("cleaned_superstore.csv")

# Load into sales table
df.to_sql(
    name="sales",
    con=engine,
    if_exists="replace",
    index=False
)