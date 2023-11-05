export const DateContainer = (props: any) => {
  return (
    <div
      className={`relative w-full flex flex-col space-y-1 py-2 px-1 bg-yellow-50 z-20 my-2`}
    >
      <h4 className={`relative w-full`}>{props.title}</h4>
      <input
        className="rounded-sm p-1 bg-blue-50"
        placeholder={props.placeholder}
        value={props.value}
        onChange={(e) => {
          props.setHandler(String(e.target.value));
        }}
      />
    </div>
  );
};
