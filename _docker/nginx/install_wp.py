import yaml
import urllib
import urllib2

mapping = {
	"weblog_title": "wordpress_title",
	"user_name": "wordpress_username",
	"admin_password": "wordpress_password",
	"pass1-text": "wordpress_password",
	"admin_password2": "wordpress_password",
	"admin_email": "wordpress_email",
	"language": "wordpress_language"
}

class NoRedirectHandler(urllib2.HTTPRedirectHandler):
	def http_error_302(self, req, fp, code, msg, headers):
		infourl = urllib.addinfourl(fp, headers, req.get_full_url())
		infourl.status = code
		infourl.code = code
		return infourl
	http_error_300 = http_error_302
	http_error_301 = http_error_302
	http_error_303 = http_error_302
	http_error_307 = http_error_302

opener = urllib2.build_opener(NoRedirectHandler())
urllib2.install_opener(opener)

req = urllib2.Request("http://localhost:8080/")
home_headers = urllib2.urlopen(req).info().dict

if "location" in home_headers and home_headers["location"] == 'http://localhost:8080/wp-admin/install.php':
	with open("/app/config/parameters.yml", 'r') as stream:
		parameters = yaml.load(stream)
		url_params = {}
		for url, param in mapping.iteritems():
			url_params[url] = parameters["parameters"][param]

		data = urllib.urlencode(url_params)
		req = urllib2.Request("http://localhost:8080/wp-admin/install.php?step=2", data)
		response = urllib2.urlopen(req)
		print response.read()
else:
	print "WP already installed"
	print home_headers
