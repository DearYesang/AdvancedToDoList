# AdvancedToDoList
HWfornbcamp230901

이상
![MVC Architecture](https://github.com/DearYesang/AdvancedToDoList/assets/139317652/d59261aa-40f3-4d39-b18f-4afc37de364e)

인스타그램 같은 이미지 및 해시태그 기반 코딩 질문을 통한 협업 앱

현실
<img width="1473" alt="스크린샷 2023-09-01 오후 3 02 53" src="https://github.com/DearYesang/AdvancedToDoList/assets/139317652/c50865b2-cd04-4046-af23-12cd2ba53cc3">

업데이트와 delete가 제대로 반영이 안되는 앱, 각각의 UserID에 해당하는 userdefault를 저장하여 데이터 일관성을 유지하는 것은 어려웠음

회고

1. 깃허브 오픈소스 라이브러리가 만능이 아니라는 것을 많이 느낌
   
1-1. 기존의 레거시에 오픈소스 라이브러리를 가져올 경우 충돌이나 버그가 잘 생기는 것을 이번 프로젝트를 통해 알게됨
1-2. 처음부터 MVC 혹은 MVMM 아키텍처 기반 앱 기획 고민의 필요성을 많이 알게 됨

2. url로 이미지를 보여주는 것에도 많은 고민이 필요하다는 것을 알게됨.

2-1. 위에서 말한 어떤 방식으로 이미지를 화면에 가져올지에 대해 고민이 필요함.
2-2. 인터넷 연결 환경에서만 이미지가 보여지는게 단점으로 보여질 수 있지만, 앱 용량을 최소화할 수 있다는 점에서 매력적임.
