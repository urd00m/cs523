import os
import pandas as pd
import sys

# Code credits: ChatGPT generated the baseline version 
# I modified it to be better and removed bugs

def aggregate_csvs(folder_path, output_filename="combined.csv"):
    """
    Aggregates all CSV files in a folder into a single CSV file.

    Args:
        folder_path (str): The path to the folder containing the CSV files.
        output_filename (str, optional): The name of the output CSV file. Defaults to "combined.csv".
    """
    all_files = os.listdir(folder_path)
    csv_files = [f for f in all_files if f.endswith('.csv')]
    
    if not csv_files:
        raise FileNotFoundError("No CSV files found in the specified folder.")

    all_df = []
    for csv_file in csv_files:
        file_path = os.path.join(folder_path, csv_file)
        try:
            df = pd.read_csv(file_path, delimiter=";")
            all_df.append(df)
        except pd.errors.EmptyDataError:
            print(f"Warning: {csv_file} is empty and will be skipped.")
        except FileNotFoundError:
             print(f"Warning: {csv_file} not found and will be skipped.")
        except Exception as e:
            print(f"Error reading {csv_file}: {e}")

    if not all_df:
        raise ValueError("No non-empty CSV files were found to combine.")

    combined_df = pd.concat(all_df, ignore_index=True)
    output_path = os.path.join(folder_path, output_filename)
    combined_df.to_csv(output_path, index=False, sep=";")

if __name__ == '__main__':
    # folder_path = input("Enter the path to the folder containing CSV files: ")
    if len(sys.argv) != 2:
        print("Usage: python data_aggregator.py <folder_path>")
        sys.exit(1)

    folder_path = sys.argv[1]
    print(f"Running agg on {folder_path}")

    try:
        aggregate_csvs(folder_path)
        print(f"Successfully combined all CSVs in '{folder_path}' into 'combined.csv'")
    except (FileNotFoundError, ValueError) as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")