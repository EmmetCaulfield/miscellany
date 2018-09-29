figure()
grid on;
hold on;

for i = 0:5,
  f=sprintf("prmembm%d.out", i);
  if i==0,
    d = load(f, '-ascii');
  else
    d += load(f, '-ascii');
  end
end

d /= 4;

semilogy(d(:,1), d(:,6:8), 'linewidth', 3);

ylabel('MB/s MB/J');
xlabel('Memory Size (log_2 B)');

