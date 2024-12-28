def print_hello():
    print("Hello World")

def parse_string_to_json(text: str) -> dict:
    lines = text.strip().split('\n')
    
    # Extract title (remove "1. Title: " prefix)
    title = lines[0].replace("1. Title: ", "").replace("Title: ", "").strip()
    
    # Extract difficulty (remove "2. Difficulty: " prefix and convert to int)
    difficulty = int(lines[2].replace("2. Difficulty: ", "").replace("Difficulty: ", "").strip())
    
    # Extract article content (everything after "3. Article:")
    article_start = text.find("Article:") + len("Article:")
    article_content = text[article_start:].strip()
    
    return {
        "title": title,
        "difficulty": difficulty,
        "content": article_content
    }

def get_current_week_number() -> str:
    from datetime import datetime
    current_date = datetime.now()
    year = current_date.year
    week_num = int(current_date.strftime("%V"))
    return f"{year}{week_num}"

if __name__ == "__main__":
    import uuid
    import json
    import os
    
    week_str = get_current_week_number()
    string1 = '''1. Title: The Mysterious Origins of Pyramids

2. Difficulty: 3

3. Article:

The pyramids are some of the most amazing structures ever built. They stand tall and proud, reminding us of ancient times. But where did the idea for these giant shapes come from? Let's explore the fascinating origins of pyramids.

The most famous pyramids are in Egypt, built thousands of years ago. But Egypt wasn’t the only place where pyramids were made. People in other parts of the world, like Central and South America, also built them! This means that the idea of building pyramids popped up in different places at different times.

Early pyramids were not always pointy like the ones we often see. The first Egyptian pyramids were more like flat-topped platforms called mastabas. They were used as tombs for important people like pharaohs. As time went on, builders started stacking mastabas on top of each other, making them higher and higher. This eventually led to the step pyramid, which looks like a staircase to the sky.

The most famous pyramids, like the Great Pyramid of Giza, are the result of many years of learning and experimenting. These pyramids had smooth sides and pointed tops. They were carefully designed and built by many workers who used simple tools and a lot of effort. These amazing structures were not just tombs; they also showed the power and importance of the pharaohs.

The people who built these structures were very skilled. They knew about math, engineering, and astronomy. They used the sun and stars to line up the sides of the pyramids correctly. These ancient people also had a system of moving heavy stones into place, sometimes using ramps and levers.

While we’re not entirely sure why pyramids became popular in different places, there’s one thing for sure: they are truly remarkable and continue to fascinate people all over the world. They remind us of the great skills and knowledge of ancient civilizations, and they serve as a window to a time long ago. They also show that humans, in different parts of the world, were able to achieve incredible things.'''

    string2 = '''Title: The Amazing Story of Michael Jordan and Nike

Difficulty: 3

Article:

Have you ever seen someone wearing cool sneakers with a special logo? You might have seen the Jumpman logo, a silhouette of a person jumping with a basketball. This logo is famous because it is connected to one of the best basketball players ever, Michael Jordan, and a big company called Nike. Let’s learn about their special story.

Michael Jordan was a very talented basketball player. He was fast, could jump really high, and always tried his best. When he was starting his career, Nike was a company that made sports shoes and clothes. They wanted to work with Michael Jordan. They thought he was so good that he could help them become even more popular.

Nike decided to create a special shoe just for Michael Jordan. They called it the "Air Jordan." This shoe was designed to help Michael play his best. It was comfortable and supportive for his feet when he was running and jumping on the court. The Air Jordan shoes were different from other sneakers, and they quickly became very popular.

People wanted to wear the same shoes as their favorite basketball player, Michael Jordan. They loved the design and how comfortable they felt. Because of this, Nike and Michael Jordan became a very successful team. They made lots of different kinds of Air Jordan shoes, and many children and adults wanted to have them.

The story of Michael Jordan and Nike is an example of how teamwork and hard work can lead to amazing things. Michael's talent and Nike’s designs created a brand that is still popular today. It also shows that believing in yourself and trying your best, just like Michael Jordan, can help you achieve great things. Wearing these sneakers isn't just about style, it's about remembering a great story of a great player and a successful company working together.'''
    string3= '''Title: The Story of Nokia: Why the Giant Fell

Difficulty: 3

Article:

Once upon a time, a company called Nokia was the king of mobile phones. Many years ago, before smartphones were so popular, almost everyone had a Nokia phone. They were strong, reliable, and fun to use. But then, things started to change, and Nokia began to lose its place at the top. Let's explore some of the reasons why this happened.

Firstly, Nokia was a bit slow to understand what people really wanted. When other companies started making phones with big, colourful screens that you could touch, Nokia kept making phones with buttons. People were excited about these new touch-screen phones, because they could do more things, like browse the internet easily. Nokia, unfortunately, did not change quickly enough.

Secondly, Nokia's phone system was not as good as the new ones. These new phones used systems that allowed people to download apps and games very easily. Nokia’s phone system was older and did not allow this so easily. People wanted new apps to play with, and it was easier to find them on other phones.

Thirdly, the company didn't always work together well internally. Different parts of the company disagreed on what to do, which made it hard to make fast decisions. When problems came up, it was hard for them to react quickly. Other companies were more united and changed faster.

Lastly, competition from other companies was very strong. New companies came along, offering phones that were very attractive and interesting to people. These companies listened to what people wanted and tried very hard to give it to them. This meant it became difficult for Nokia to compete.

So, even though Nokia was a very big and important company, they made some mistakes. They didn't change fast enough, their system wasn't as good, they didn't work together as well, and other companies became too strong. The story of Nokia teaches us that even big companies need to be careful, listen to their customers, and always try to improve.'''
    result_array = []
    result_array.append(parse_string_to_json(string1))
    result_array.append(parse_string_to_json(string2))
    result_array.append(parse_string_to_json(string3))

    # Create articles directory if it doesn't exist
    os.makedirs('articles', exist_ok=True)
    
    wkjson = json.loads('{"Data":[]}')
    wkname = f"{week_str}.json"
    # Save each article with UUID filename
    for article in result_array:
        article_id = str(uuid.uuid4())
        filename = f"articles/{article_id}.json"
        
        # Save article content to individual file
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump({"content": article["content"]}, f, ensure_ascii=False, indent=2)
        
        # Add article metadata to weekly JSON
        wkjson["Data"].append({
            "id": article_id,
            "title": article["title"],
            "difficulty": article["difficulty"]
        })
    
    # Save weekly JSON file
    with open(wkname, 'w', encoding='utf-8') as f:
        json.dump(wkjson, f, ensure_ascii=False, indent=2)
