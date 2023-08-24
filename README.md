
<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MS-PL License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/Symbolics/cl-gists">
    <img src="https://lisp-stat.dev/images/stats-image.svg" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Github Gists</h3>

  <p align="center">
  Common lisp wrapper for Github's gists API
	<br />
    <a href="https://symbolics.github.io/cl-gists"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Symbolics/cl-gists/issues">Report Bug</a>
    ·
    <a href="https://github.com/Symbolics/cl-gists/issues">Request Feature</a>
    ·
    <a href="https://symbolics.github.io/cl-gists/">Reference Manual</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About the Project

An interface to the github REST API.  This systems was originally developed developed by [Rudolph Miller](https://github.com/rudolph-miller/cl-gists) in 2015, however as of 2023 it has been abandoned for several years and no longer works with the current Github API.  This fork is for maintenance purposes.

### Built With

* [alexandria](https://gitlab.common-lisp.net/alexandria/alexandria)


<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

An ANSI Common Lisp implementation. Developed and tested with
[SBCL](https://www.sbcl.org/).

### Installation

#### Automated Installation

If you have [Quicklisp](https://www.quicklisp.org/beta/) installed,
you can load `cl-gists` and all of its dependencies with:

```lisp
(ql:quickload :cl-gists)
```

<!-- USAGE EXAMPLES -->
## Usage
```lisp
(let ((gist (make-gist :description "sample"
                       :public t
                       :files '((:name "file1" :content "text1") (:name "file2" :content "text2")))))
  (create-gist gist))
;; => #S(GIST ...)
```

For more examples see the `examples/` directory in the source code.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are greatly appreciated.  Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on the code of conduct, and the process for submitting pull requests.

<!-- LICENSE -->
## License

Distributed under the MS-PL License. See [LICENSE](LICENSE) for more information.
The [original version](https://github.com/rudolph-miller/cl-gists) is licensed under the MIT license.

## Notes
The tests have been updated to work with the latest github API, however the tests need to authenticate to github using a particular user.  Some tests make assumptions about the contents of the users git repository.  For example the 'starred' tests checks that we can use the `:starred` keyword to `get-gists`, but if the user you're running the tests with doesn't have any starred gists then the test will fail.


<!-- CONTACT -->
## Contact

Project Link: [https://github.com/Symbolics/cl-gists](https://github.com/Symbolics/cl-gists)



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Symbolics/cl-gists.svg?style=for-the-badge
[contributors-url]: https://github.com/Symbolics/cl-gists/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Symbolics/cl-gists.svg?style=for-the-badge
[forks-url]: https://github.com/Symbolics/cl-gists/network/members
[stars-shield]: https://img.shields.io/github/stars/Symbolics/cl-gists.svg?style=for-the-badge
[stars-url]: https://github.com/Symbolics/cl-gists/stargazers
[issues-shield]: https://img.shields.io/github/issues/Symbolics/cl-gists.svg?style=for-the-badge
[issues-url]: https://github.com/Symbolics/cl-gists/issues
[license-shield]: https://img.shields.io/github/license/Symbolics/cl-gists.svg?style=for-the-badge
[license-url]: https://github.com/Symbolics/cl-gists/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/company/symbolics/
