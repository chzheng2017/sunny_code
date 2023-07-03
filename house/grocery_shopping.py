import json

def generate_shopping_list(store_name, store_data):
    print(f"\nGenerating shopping list for {store_name}...")
    selected_items = []

    while True:
        print(f"\nAvailable lists for {store_name}:")
        list_names = list(store_data.keys())
        for i, list_name in enumerate(list_names, start=1):
            print(f"{i}. {list_name}")

        list_choice = input("Enter the number of the list to shop from (or 'q' to finish): ")

        if list_choice.lower() == "q":
            break

        try:
            list_choice = int(list_choice)
            if list_choice < 1 or list_choice > len(list_names):
                print("Invalid choice. Please try again.")
                continue

            list_name = list_names[list_choice - 1]
            print(f"\nAvailable items for {list_name}:")
            shopping_list = store_data.get(list_name)

            if not shopping_list:
                print("No items available for this list.")
                continue

            for i, item in enumerate(shopping_list, start=1):
                print(f"{i}. {item}")

            while True:
                item_choice = input("Enter the number of an item to add it to the shopping list (or 'q' to go back): ")

                if item_choice.lower() == "q":
                    break

                try:
                    item_choice = int(item_choice)
                    if item_choice < 1 or item_choice > len(shopping_list):
                        print("Invalid choice. Please try again.")
                        continue

                    selected_item = shopping_list[item_choice - 1]
                    if selected_item in selected_items:
                        print("Item already selected. Please choose another item.")
                    else:
                        selected_items.append((store_name, list_name, selected_item))
                        print(f"Added '{selected_item}' to the shopping list!")

                except ValueError:
                    print("Invalid choice. Please try again.")

        except ValueError:
            print("Invalid choice. Please try again.")

    return selected_items


def grocery_shopping():
    with open("aldi.json") as file:
        aldi_data = json.load(file)

    with open("costco.json") as file:
        costco_data = json.load(file)

    with open("grand_asia.json") as file:
        grand_asia_data = json.load(file)

    print("Welcome to the grocery shopping app!")
    print("Available stores:")
    stores = {
        "1": ("ALDI", aldi_data),
        "2": ("Costco", costco_data),
        "3": ("Grand Asia", grand_asia_data)
    }

    selected_items = []

    while True:
        print("\nAvailable stores:")
        for store_choice, (store_code, _) in stores.items():
            print(f"{store_choice}. {store_code}")

        store_choice = input("Enter the number of the store to shop from (or 'q' to quit): ")

        if store_choice.lower() == "q":
            break

        try:
            store_name, store_data = stores.get(store_choice)
            store_items = generate_shopping_list(store_name, store_data)
            selected_items.extend(store_items)

        except KeyError:
            print("Invalid choice. Please try again.")

    return selected_items


def save_shopping_list(shopping_list):
    with open("shopping_list.json", "w") as file:
        json.dump(shopping_list, file)


def load_shopping_list():
    try:
        with open("shopping_list.json") as file:
            shopping_list = json.load(file)
            return shopping_list
    except FileNotFoundError:
        return []


def main():
    selected_items = load_shopping_list()
    selected_items.extend(grocery_shopping())
    save_shopping_list(selected_items)

    print("\nReady to go shopping?")
    ready = input("Enter 'yes' when you're ready to go shopping or 'no' to exit: ")

    if ready.lower() == "yes":
        store_name = input("Which store are you going to? ")
        print(f"\nFinal shopping list for {store_name}:")
        store_items = [item for item in selected_items if item[0] == store_name]

        if len(store_items) == 0:
            print("No items to buy from this store.")
        else:
            store_list = []
            for _, list_name, item in store_items:
                if item not in store_list:
                    store_list.append(item)
                    print(f"- {item} ({list_name})")

            selected_items = [item for item in selected_items if item not in store_items]
            save_shopping_list(selected_items)

        print("Thank you for using the grocery shopping app!")

    elif ready.lower() == "no":
        print("Thank you for using the grocery shopping app!")

    else:
        print("Invalid choice. Thank you for using the grocery shopping app!")


if __name__ == "__main__":
    main()
