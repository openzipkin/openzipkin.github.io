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
			steps {
				deleteDir()
				checkout scm
			}
		}

		stage('Check environment') {
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
			steps {
				sh '''
				set -xeuo pipefail

				srchash="$(git rev-parse --short HEAD)"
				commitmsg="Automatic site generation from ${srchash}"

				builddir="$(mktemp -d)"
				mv _site "${builddir}/"
				ls -lR "${builddir}/_site/"

				git fetch origin
				git reset --hard
				git checkout asf-site
				git log -3
				git status

				rsync -avrh --delete --exclude=".git" "${builddir}/_site/" ./
				git status
				git diff

				git add .

				if [ -z "$(git status --porcelain)" ]; then
					echo 'No changes to commit/push'
				else
					git commit -m "$commitmsg"
					git pull --rebase
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
