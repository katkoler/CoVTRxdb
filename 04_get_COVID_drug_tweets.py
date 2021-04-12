import snscrape.modules.twitter as sntwitter
import csv

drugs  = ["hydroxychloroquine", "hydroxychloroquin", "hydoxychloroquine", "remdesivir", "chloroquine", "theanine", "hidroxicloroquina", "oxygen", "honey", "vitamin d", "indole", "carbon", "vitamin c", "zinc", "hydoxychloroquin", "sage", "azithromycin", "dexamethasone", "lime", "ivermectina", "ibuprofen",  "paracetamol", "steam", "a hcq", "vitamin a", "interferon", "piperine", "ginger", "rutin", "copper", "favipiravir", "aerosols", "ivermectin", "garlic", "nicotine", "tocilizumab", "lopinavir", "hcq", "chlorine dioxide", "doxycycline", "oleandrin", "quercetin", "thiamine", "chlorine dioxide", "doxycycline", "oleandrin", "quercetin", "thiamine", "azythromycin","sarilumab","sulfate","ritonavir","phosphate","anakinra","methylprednisolone","arsenic","thalidomide","nitric oxide","enoxaparin","losartan","naproxen","imatinib","siltuximab","kpt-330","nintedanib", "convalescent plasma", "plasma", "TCM", "chinese medicine", "traditional chinese medicine", "stem cells", "mesenchymal stem cells"]

start_date = "2020-01-01"
end_date = "2020-09-05"


for drug in drugs:
    print(drug)
    keyword = drug + "(COVID OR SARS OR coronavirus OR 2019-nCov OR nCov)"
    maxTweets = 1000000

    #Open/create a file to append data to
    csvFile = open('tweets/%s_tweets.csv' % drug, 'a', newline='', encoding='utf8')

    #Use csv writer
    csvWriter = csv.writer(csvFile)
    # csvWriter.writerow(['id','date','tweet']) 
    csvWriter.writerow([u"drug_name",u"id",u"link",u"date",u"username",u"content",u"lang",u"likeCount",u"retweetCount",u"replyCount"])

    for i,tweet in enumerate(sntwitter.TwitterSearchScraper(keyword + 'since:' + start_date + ' until:' + end_date + '-filter:replies -filter:retweets').get_items()) :
            
            if i > maxTweets :
                print("max tweets reached")
                print(tweet.date)
                break      
            # csvWriter.writerow([tweet.id, tweet.date, tweet.renderedContent])
            csvWriter.writerow([drug, tweet.id, tweet.url, tweet.date, tweet.username, tweet.content.encode("utf-8"), tweet.lang, tweet.likeCount, tweet.retweetCount, tweet.replyCount])
            
    csvFile.close()