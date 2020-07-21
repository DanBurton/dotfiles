## Misc notes and instructions for mac

Install stack

```bash
curl -sSL https://get.haskellstack.org/ | sh
```

Install homebrew

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install nix

```bash
curl https://nixos.org/nix/install | sh
```

Spectacle  
https://www.spectacleapp.com/

Remapping caps lock to ctrl if held, esc if not.  
http://brettterpstra.com/2017/06/15/a-hyper-key-with-karabiner-elements-full-instructions/

Set up git GPG signing  
https://unknownparallel.wordpress.com/2016/09/02/gpg-signing-for-github-mac/

Spacemacs

```bash
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
git checkout develop
git pull
ln -s ~/github.com/danburton/dotfiles/spacemacs ~/.spacemacs
```

Haskell support for spacemacs

```
mkdir -p ~/.local/bin
cp ~/github.com/danburton/dotfiles/sbin/stack-from-project-root.sh ~/.local/bin/stack-from-project-root.sh
```

Problems with emacs 26 and spacemacs develop branch?

https://github.com/syl20bnr/spacemacs/issues/10438#issuecomment-387449474

```bash
cd ~/.emacs.d/.cache/stable-elpa/26.1
tar -xzvf spacelpa-0.300.tar.gz
echo -n "0.300" > version
```

Fixing "xcrun: error: invalid active developer path ..." on mac
```bash
xcode-select --install
```
(See https://apple.stackexchange.com/questions/254380/macos-sierra-invalid-active-developer-path)

iterm2 new tab same dir
http://nateeagle.com/2013/03/08/open-new-tabs-in-iterm-in-the-current-directory/
