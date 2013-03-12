require 'curb'
require 'mysql'
require 'nokogiri'

def write_img(id, img)
	unless id.nil?
		target = File.open('magic_img/'+id.to_s+'.jpg', 'w')
		target.write(Curl::Easy.perform((img)).body_str)
		target.close()
	end
end

con = Mysql.new( 'localhost', 'root', 'password', 'magic' )
sets = []
collide = 0
since_last = 0

noko = Nokogiri::HTML(Curl::Easy.perform('http://magiccards.info/sitemap.html').body_str)
sets = noko.xpath("/html/body/table[2]/tr/td[*]/ul[*]/li[*]/ul/li[*]/small/text()")
#noko = Nokogiri::HTML(Curl::Easy.perform('http://magiccards.info/%s/en.html' % set).body_str)

sets.each{ |set|
	noko = Nokogiri::HTML(Curl::Easy.perform('http://magiccards.info/%s/en.html' % set).body_str)
	#max = noko.xpath("/html/body/table[2]/tr/td[3]/text()").to_s.gsub(/cards/,'').strip
	numbers = noko.xpath("/html/body/table[3]/tr[*]/td[1]/text()")

	numbers.each{ |number|
		c = Curl::Easy.perform('http://magiccards.info/%s/en/%s.html' % [set, number])
		noko = Nokogiri::HTML(c.body_str)

		card_name = noko.xpath("/html/body/table[3]/tr/td[2]/span/a/text()").to_s;
		if card_name.nil?
			sleep(1/4)
			next
		end
		card_url  = 'http://magiccards.info' + noko.xpath("/html/body/table[3]/tr/td[2]/span/a/@href").to_s;
		card_img  = noko.xpath('/html/body/table[3]/tr/td[1]/img/@src').to_s;

		card_first = card_name[0]
		card_last  = card_name[-1].upcase

		card_id = nil

		card = [card_name, card_first, card_last, card_url, card_img]
		puts card_name

		begin
			
			card = card.map{ |x| con.escape_string(x) }

			rs = con.query( "SELECT * FROM cards where name = '%s'" % card[0])
			if rs.num_rows > 0
				collide += 1
				puts ' found %s making this the %d collision and %d since the last' % [card_name, collide, since_last]
				since_last = 0
				sleep(1/4)
				next
			else
				since_last += 1
				con.query( "INSERT INTO cards (name, first, last, img_url, url) VALUES('%s','%s','%s','%s','%s' )" % card ) 
				rs = con.query( "SELECT LAST_INSERT_ID()" )
				id = rs.fetch_row[0]
			end

		rescue Mysql::Error => e
			puts e.errno
			puts e.error
		end

		write_img(id, card_img)
		sleep(1/4)
	}
}

con.close if con
