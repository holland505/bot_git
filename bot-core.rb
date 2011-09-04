#!/usr/local/bin/ruby -Ku
# -*- coding: utf-8 -*-

require 'rubygems'
require 'twitter'
require 'rexml/document'
require 'spreadsheet'

class Bot
    public
    def initialize
        $CONSUMER_KEY = 'h1vfPKhYwO3sfkgMNlPKg'
        $CONSUMER_SERCRET = 'aouOvpWqoczxyKwsfPmUo9rZnamaropEMLvBVZyNdbs'
        $ACCESS_TOKEN = '236280697-vcn25oxDMuWfVCcoK20qZzuMfR0EkEOWzmdYTMcz'
        $ACCESS_TOKEN_SERCTET = '73TRPUBveXaejmnLbATRAVwSr87I35iapmLuSc4uU'
        Twitter.configure do |config|
            config.consumer_key = $CONSUMER_KEY
            config.consumer_secret = $CONSUMER_SERCRET
            config.oauth_token = $ACCESS_TOKEN
            config.oauth_token_secret = $ACCESS_TOKEN_SERCTET
        end
        @client = Twitter::Client.new
    end
    
    def xmlPost(xml_file)
        file = REXML::Document.new(File.read(xml_file))
        comments = file.root().get_elements('comment')
        comment = comments[rand(comments.length)].text
        msg = @client.update(comment)
        return msg
    end
	
    #xlsから値を抜き取ってランダムにツイートする
    def xlsPost(xls_file)
        list = []
        book = Spreadsheet.open(xls_file)
        sheet  = book.worksheet(0)
        1.upto(sheet.row_count - 1).map do |i|
            meigen = sheet[i,1]
            person = sheet[i,2]
            sakuhin = sheet[i,3]
            comments =[]
            comments.push(meigen,person,sakuhin)
            list.push(comments)
            #print("[#{meigen.to_s}]\t[#{person.to_s}]\t[#{sakuhin.to_s}]\n")
        end
        
        comment = list[rand(list.length)]
        post = "「#{comment[0]}」【#{comment[1]}】-  #{comment[2]} #kotoba #meigen #anime"
        msg  = @client.update(post)
        return msg
    end
    
    def follow_reply
        followers = []
        @client.followers.each do |id|
            followers << id
        end
        friends = []
        @client.friends.each do |id|
            friends << id
        end
        
        follower_names = @client.follower_ids
        friend_names = @client.friend_ids
        add_followers = followers	 #差分を取る
        add_followers.each do |id|
            @client.friendship_create(id)
        end
    end
end
