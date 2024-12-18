import random
import faker

# Initialize Faker to generate random values
fake = faker.Faker()

# Predefined lists for variation
ip_addresses = [fake.ipv4() for _ in range(2000)]  # Generate a list of random IP addresses
countries = [
    "United States", "Canada", "Mexico", "Brazil", "Argentina", "United Kingdom", "Germany", "France", "Italy", "Spain",
    "Australia", "Japan", "South Korea", "China", "India", "Russia", "South Africa", "Egypt", "Nigeria", "Kenya",
    "Indonesia", "Thailand", "Vietnam", "Turkey", "Saudi Arabia", "United Arab Emirates", "Israel", "Pakistan", "Bangladesh", "Chile"
]
organizations = [
    "Microsoft", "Apple", "Google", "Amazon", "Facebook", "IBM", "Intel", "Oracle", "Samsung", "Sony",
    "Tesla", "Toyota", "Volkswagen", "BMW", "Mercedes-Benz", "General Electric", "Huawei", "Siemens", "Cisco", "Accenture",
    "Deloitte", "PwC", "KPMG", "Ernst & Young", "HSBC", "JPMorgan Chase", "Goldman Sachs", "Morgan Stanley", "Citigroup", "Barclays"
]

# Function to generate random dataset
def generate_data(num_lines=2000):
    data = []
    for _ in range(num_lines):
        ip = ip_addresses.pop()  # Get a random IP address and remove from the list
        port = random.randint(200, 600)  # Random port number between 500 and 550
        device = f'Server{random.randint(1, 100)}'  # Random server name
        banner = fake.sentence()  # Random sentence
        timestamp = fake.date_time_this_decade().isoformat()  # Random timestamp
        hostnames = fake.hostname()
        country = random.choice(countries)
        city = fake.city() 
        operating_system = fake.word()
        organization = random.choice(organizations)

        # Format the line and add to the data list
        data.append(f"{ip},{port},\"{device}\",\"{banner}\",{timestamp},{hostnames},{country},{city},{operating_system},{organization}")

    return data

# Function to write data to a CSV file
def write_to_file(filename, num_lines=2000):
    data = generate_data(num_lines)
    with open(filename, "w") as f:
        # Write the header
        f.write("IP,Port,Device,Banner,Timestamp,Hostnames,Country,City,Operating System,Organization\n")
        # Write the generated data
        for line in data:
            f.write(line + "\n")
    print(f"{num_lines} lines of data written to {filename}")

# Call the function to generate 1000 lines of data and write to a file
write_to_file("data.csv", num_lines=2000)
