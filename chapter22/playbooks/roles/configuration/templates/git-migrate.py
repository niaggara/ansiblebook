from github import Github
import os
import json

#Github
GH_ACCESS_TOKEN = os.environ['GH_ACCESS_TOKEN']
#Gitea
GITEA_ACCESS_TOKEN = os.environ['GITEA_ACCESS_TOKEN']
GITEA_USER = ""
GITEA_PASS = ""
TARGET_HOST = "https://git.yourserver.co"
MIGRATE_URI = "/api/v1/repos/migrate"
ENDPOINT = "%s%s" % (TARGET_HOST, MIGRATE_URI)

g = Github(GH_ACCESS_TOKEN)

EXCLUDE = []

def getRepos(g):
	repos = []
	for repo in g.get_user().get_repos():
			r = {}
			r['name'] = str(repo.name)
			r['url'] = str(repo.url)
			r['description'] = str(repo.description)
			r['private'] = str(repo.private)
    		repos.append(r)
	return repos

def createRepo(source_url,name,description,private):
	headers = { "accept": "application/json", "content-type": "application/json" }
	headers["Authorization"] = "token %s" % (GITEA_ACCESS_TOKEN)

	migrate_data = { "mirror": "false",  "uid": 1 }
	migrate_data["auth_password"] = "%s" % (GITEA_PASS)
	migrate_data["auth_username"] = "%s" % (GITEA_USER)
	migrate_data["description"] = "%s" % (description)
	migrate_data["repo_name"] = "%s" % (name)
	migrate_data["private"] = "%s" % (private)
	migrate_data["clone_url"] = "%s" % (source_url)

	try:
		r = requests.post(url=ENDPOINT, data=json.dumps(migrate_data), headers=json.dumps(headers))

		if r.status_code != 200:
			return "Non-OK Response: %s" % (r.status_code)
		else:
			return "Done: %s" % (source_url)
	except as Exception e:
		return e

def runMigration(r,x):
	exclude_repos = x
	for repo in r:
		if repo not in exclude_repos:
			print "Working on %s" % (repo['name'])
			print createRepo(repo['url'],repo['name'],repo['description'],repo['private'])
		else:
			print "Excluding %s" % (repo['name'])
	return "Done"

if __name__ == '__main__':
	repos = getRepos(g)
	print(runMigration(repos,EXCLUDE))



