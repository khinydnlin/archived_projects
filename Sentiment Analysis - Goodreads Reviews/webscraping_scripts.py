#webscraping reviews and ratings

#installing packages
pip install selenium

#loading necessary packages
import time
import json
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException

class ReviewsScraper:
    def __init__(self):
        self.driver = self.setup_driver()
        self.max_clicks = 50 #change depending on the amount of reviews

    def setup_driver(self):
        chrome_options = Options()
        chrome_options.add_argument("--non-headless")
        chrome_options.add_argument("--window-size=1920x1080")
        driver_path = 'C:\\chromedriver-win64\\chromedriver.exe' #replace with your chromedriver path
        service = Service(executable_path=driver_path)
        driver = webdriver.Chrome(service=service, options=chrome_options)
        driver.implicitly_wait(10)
        return driver

    def scrape_reviews(self, url):
        self.driver.get(url)
        reviews = []
        previous_length = 0
        count = 0

        while count < self.max_clicks:
            current_reviews = self.driver.find_elements(By.XPATH, '//article[contains(@class, "ReviewCard")]')

            # Extract reviews
            for review in current_reviews[previous_length:]:
                try:
                    rating_element = review.find_element(By.XPATH, './/span[contains(@class, "RatingStars__small")][@aria-label]')
                    aria_label = rating_element.get_attribute('aria-label')
        
                    if aria_label:
                        print("Found aria-label:", aria_label)
                        rating = aria_label.split()[1]  # extract the rating from a string
                        print("Extracted rating:", rating)
                    else:
                        raise AttributeError("No 'aria-label' attribute found")  # Raise an error to be caught
        
                except (NoSuchElementException, AttributeError) as e:
                    print(f"Rating element not found or missing 'aria-label': {e}")
                    rating = "Not Available" 

 
                review_text_elements = review.find_elements(By.XPATH, './/section[contains(@class,"ReviewText__content")]//span[@class="Formatted"]')
                review_text = ' '.join([elem.text for elem in review_text_elements]).replace('\n', ' ')
                reviews.append({
                    'rating': rating,
                    'review_text': review_text
                })

            # Save data incrementally
            self.save_data(reviews)

            previous_length = len(reviews)

            try:
                load_more_button = WebDriverWait(self.driver, 10).until(
                    EC.element_to_be_clickable((By.XPATH, "//span[@data-testid='loadMore']"))
                )
                self.driver.execute_script("arguments[0].scrollIntoView(true);", load_more_button)
                time.sleep(2)
                load_more_button.click()
                time.sleep(5)  # Wait for new reviews to load
                count += 1
            except Exception as e:
                print(f"Failed to load or click on 'Load More': {str(e)}")
                break

        return reviews

    def save_data(self, reviews):
        # Save the scraped data to a file
        with open('georgeorwell_ratings_reviews.json', 'w', encoding='utf-8') as file:
            json.dump(reviews, file, indent=4, ensure_ascii=False)

    def close_driver(self):
        self.driver.quit()

# Usage
if __name__ == "__main__":
    scraper = ReviewsScraper()
    reviews = scraper.scrape_reviews('...') #replace with book id path
    scraper.close_driver()


