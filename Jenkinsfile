pipeline {
	agent {
		label 'git-websites'
	}

	options {
		buildDiscarder(logRotator(numToKeepStr: '10'))
		timestamps()
	}

	triggers {
		pollSCM('H/15 * * * *')
	}

	stages {
		stage('SCM Checkout') {
			when {
				anyOf {
//					branch 'master'
					changeRequest target: 'master'
				}
			}
			steps {
				deleteDir()
				checkout scm
				sh 'git submodule update --init --recursive'
			}
		}

		stage('Check environment') {
			when {
				anyOf {
					branch 'master'
					changeRequest target: 'master'
				}
			}
			steps {
				sh 'env'
				sh 'pwd'
				sh 'ls'
				sh 'alias'
				sh 'git config --list --local'
				sh 'git config --list --global'
				sh 'git status'
			}
		}

		stage('Install Jekyll') {
			when {
				anyOf {
					branch 'master'
					changeRequest target: 'master'
				}
			}
			steps {
				sh '''
				. "${rvm_path}/scripts/rvm"
				set -e
				gem install bundler
				bundle install
				'''
			}
		}

		stage('Build site') {
			when {
				anyOf {
					branch 'master'
					changeRequest target: 'master'
				}
			}
			steps {
				sh '''
				. "${rvm_path}/scripts/rvm"
				set -e 
				bundle exec jekyll build --verbose
				'''
				sh 'ls -lR _site'
			}
		}

		stage('Publish') {
			when {
				branch 'master'
			}
			environment {
				// GH Personal access token @abesto
				GITUSER = credentials('2d27b827-20c2-4173-ac84-f3abc308fc88')
			}
			steps {
				sh '''
				set -xeuo pipefail

				srchash="$(git rev-parse --short HEAD)"
				commitmsg="Automatic site generation from ${srchash}"

				builddir="$(mktemp -d)"
				mv _site "${builddir}/"
				ls "${builddir}/_site/"

				git fetch origin asf-site:asf-site
				git reset --hard
				git checkout asf-site
				git log -3
				git submodule update --init --recursive
				git status
				cp ./zipkin-api-source/*.yaml ./zipkin-api/
				git add ./zipkin-api/*.yaml
				git commit -m "force adds zipkin-api" || true

				rsync -avrh --delete --exclude=".git" --exclude=".gitmodules" --exclude="./zipkin-api-source" --exclude="./zipkin-api/*.yaml" "${builddir}/_site/" ./
				git status
				git diff

				git add .

				if [ -z "$(git status --porcelain)" ]; then
					echo 'No changes to commit/push'
				else
					git config --local credential.helper "!p() { echo username=\\$GITUSER_USR; echo password=\\$GITUSER_PSW; }; p"
					git commit -m "$commitmsg"
					git log asf-site -3
					git push origin asf-site
				fi
				'''
			}
		}
	}

	post {
		always {
			deleteDir()
		}
	}
}
