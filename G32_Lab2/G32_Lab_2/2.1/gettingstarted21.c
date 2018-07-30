int main()
{	int a[5]={1,20,3,4,5};
	int max_val=a[0];
	int i;
	for(i=0; i<sizeof(a)/sizeof(a[0]);i++){
		if(max_val<a[i]){
			max_val=a[i];
			}
	}
	printf("%d", max_val);
}
